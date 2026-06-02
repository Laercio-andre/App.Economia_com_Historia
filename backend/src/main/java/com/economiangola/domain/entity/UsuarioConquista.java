// src/main/java/com/economiangola/domain/entity/UsuarioConquista.java
package com.economiangola.domain.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "usuario_conquistas", uniqueConstraints = {
        @UniqueConstraint(columnNames = {"usuario_id", "conquista_id"})
})
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UsuarioConquista extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "conquista_id", nullable = false)
    private Conquista conquista;
}
