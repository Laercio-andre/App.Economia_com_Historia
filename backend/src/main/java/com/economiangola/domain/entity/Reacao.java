// src/main/java/com/economiangola/domain/entity/Reacao.java
package com.economiangola.domain.entity;

import com.economiangola.domain.enums.TipoReacao;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "reacoes", uniqueConstraints = {
        @UniqueConstraint(columnNames = {"usuario_id", "conteudo_id"})
})
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Reacao extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "conteudo_id", nullable = false)
    private Conteudo conteudo;

    @Enumerated(EnumType.STRING)
    @Column(name = "tipo_reacao", nullable = false, length = 20)
    private TipoReacao tipoReacao;
}
