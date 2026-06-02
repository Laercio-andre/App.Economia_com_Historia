// src/main/java/com/economiangola/domain/entity/TipoPerfil.java
package com.economiangola.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "tipos_perfil")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TipoPerfil extends BaseEntity {

    @Column(name = "nome", nullable = false, unique = true, length = 50)
    private String nome;

    @Column(name = "descricao", length = 255)
    private String descricao;

    @ManyToMany
    @JoinTable(
            name = "perfil_permissoes",
            joinColumns = @JoinColumn(name = "tipo_perfil_id"),
            inverseJoinColumns = @JoinColumn(name = "permissao_id")
    )
    @Builder.Default
    private List<Permissao> permissoes = new ArrayList<>();
}
